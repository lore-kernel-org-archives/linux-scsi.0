From: Anil kumar <anils_r@yahoo.com>
Subject: scsi command timeout_per_command and scsi device timeout
Date: Tue, 20 Jan 2009 17:07:09 -0800 (PST)
Message-ID: <521553.39263.qm@web32404.mail.mud.yahoo.com>
Reply-To: anils_r@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web32404.mail.mud.yahoo.com ([68.142.207.197]:42805 "HELO
	web32404.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757431AbZAUBNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 20:13:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi,

What is the relation between scsi_cmd->timeout_per_command and scsi_device->timeout?
I set a timeout value for scsi_device->timeout in slave_configure, but I don't see this value being taken by scsi_cmd->timeout_per_command.

If they are not related, then how can I set command timeout for all commands to my driver to avoid command timeouts.

with regards,
  Anil


      
