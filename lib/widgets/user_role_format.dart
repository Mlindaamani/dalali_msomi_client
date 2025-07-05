enum UserRole { TENANT, BROKER, CARGO_DRIVER, PROPERTY_OWNER }

String getUserRoleLabel(UserRole role) {
  return role
      .toString()
      .split('.')
      .last
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

String getUserRoleIcon(UserRole role) {
  switch (role) {
    case UserRole.TENANT:
      return 'assets/icons/tenant_icon.png';
    case UserRole.BROKER:
      return 'assets/icons/broker_icon.png';
    case UserRole.CARGO_DRIVER:
      return 'assets/icons/cargo_driver_icon.png';
    case UserRole.PROPERTY_OWNER:
      return 'assets/icons/property_owner_icon.png';
  }
}

String getUserRoleColor(UserRole role) {
  switch (role) {
    case UserRole.TENANT:
      return '#64D8CB';
    case UserRole.BROKER:
      return '#00796B';
    case UserRole.CARGO_DRIVER:
      return '#FF9800';
    case UserRole.PROPERTY_OWNER:
      return '#4CAF50';
  }
}

String getUserRoleDescription(UserRole role) {
  switch (role) {
    case UserRole.TENANT:
      return 'A person who rents a property.';
    case UserRole.BROKER:
      return 'An intermediary who facilitates property transactions.';
    case UserRole.CARGO_DRIVER:
      return 'A driver responsible for transporting goods.';
    case UserRole.PROPERTY_OWNER:
      return 'An individual who owns a property.';
  }
}

String getUserRoleTooltip(UserRole role) {
  switch (role) {
    case UserRole.TENANT:
      return 'Click to view tenant details';
    case UserRole.BROKER:
      return 'Click to view broker details';
    case UserRole.CARGO_DRIVER:
      return 'Click to view cargo driver details';
    case UserRole.PROPERTY_OWNER:
      return 'Click to view property owner details';
  }
}
