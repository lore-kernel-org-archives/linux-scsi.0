From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] [PATCH 0/5] qla4xxx: Add IPv6 support and misc
Date: Thu, 03 May 2007 13:42:45 +0200
Message-ID: <4639CAB5.7090308@s5r6.in-berlin.de>
References: <1178157870.20898.35.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:38242 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031040AbXECLnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2007 07:43:37 -0400
In-Reply-To: <1178157870.20898.35.camel@iscsi-sles10>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> The following set of patches 
>         1. add support for ipv6 for qla4032 
>         2. provide bug fixes
>         3. misc. support 
> 
> Patch 1/5  
> has changes to the driver and firmware related structures to
>         1. clean up and make the firmware related structures look linux like.
>         2. add fields/structures for ipv6 support
>         3. add support for capaturing all AEN types in a ring buffer, to aid troubleshooting.
>         4. abstract the functions for sending commands to the HBA (i.e., sending via Request Queue or Mailbox registers) so that the underlying functions can be different in future hardware. Also mailbox commands which are not performance critical may be sent via Request Queues (using mailbox iocbs).
>         
> Patch 2/5 
> has the following changes for initialization routines.
>         1. fix qla4x00_pci_config()
>         2. fix in qla4xxx_add_device_dynamically(), so that a new target coming online and existing targets which went offline and then came back online are differentiated.
>         3. In qla4xxx_build_ddb_list() the firmware ddb entry's state needs to be updated by calling qla4xxx_get_fwddb_entry() after qla4xxx_set_ddb_entry().
[...]

I have no technical comments, just a formal one:

Even though you perhaps don't expect the patches to be committed as-is,
you should give each patch an own descriptive patch title (instead of
naming them all "qla4xxx: Add IPv6 support and misc").  Also, you could
put the above descriptions into the individual patch descriptions.
-- 
Stefan Richter
-=====-=-=== -=-= ---==
http://arcgraph.de/sr/
