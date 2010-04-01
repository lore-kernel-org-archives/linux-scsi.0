From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [LSF/VM TOPIC] TCM v4.0 generic configfs fabric infrastructure
Date: Wed, 31 Mar 2010 23:23:34 -0700
Message-ID: <1270103014.2682.58.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: lsf10-pc@lists.linuxfoundation.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Greetings all,

[Topic]
TCM v4.0 generic configfs fabric infrastructure

[Abstract]
This discussion focuses on the generic configfs fabric module
infrastructure WIP currently under development for TCM v4.0 which aims
to provide a generic set of struct config_item_types available for
target mode fabric module configfs usage, and set of context specific
macros available for adding target mode fabric module dependent RW
configfs attributes.  The main goal is to enable the development of new
and conversion of existing target mode fabric modules without the hard
requirement of fabric module authors needing to implement their own
configfs code.

The patch announcements for the first and second series of TCM code and
LIO-Target and TCM_Loop fabric module conversion commits into
lio-core-2.6.git/lio-4.0 can be found here:

http://marc.info/?l=linux-scsi&m=126688745100913&w=2
http://marc.info/?l=linux-scsi&m=126710672402056&w=2

and code for implementing the generic WWN, TPGT, LUN, NodeACL and
MappedLUN struct configs_item_types is available here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/target_core_fabric_configfs.c;hb=lio-4.0

Best,

--nab

