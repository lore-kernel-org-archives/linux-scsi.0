From: Eric Johnson <ericjohnson007@yahoo.com>
Subject: maximum no of LUNs and targets
Date: Fri, 28 Feb 2003 12:02:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030228200226.60826.qmail@web20713.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings !

I want to know what is the  limit of number of targets
per bus , number of LUNs per target for the scsi layer
in Linux.  Do these need to be configured ?

I am working on Fibre channel  application . I need to
find the FCP lun-OS lun mapping information for each
HBA. The HBA API doesnt seem to give FCP lun-OS lun
information . But it does seem to show tne target
mapping ( FC portid -Target id ) information. So can i
do a a FC report luns on the target to find the OS Lun
information ?  If there are no limits on the number of
luns , i think i can assume that the FC reported lun
no would be same as OS Lun no.


Thanks a lot in advance  !!

Eric 





__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - forms, calculators, tips, more
http://taxes.yahoo.com/
