From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH] qla4xxx: bug fixes
Date: Mon, 29 Jan 2007 10:34:05 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC07828CF9@AVEXCH1.qlogic.org>
References: <1169914102.4392.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:50466 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXA2SeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:34:07 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1169914102.4392.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>

> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Saturday, January 27, 2007 8:08 AM
> On Mon, 2007-01-22 at 12:26 -0800, David C Somayajulu wrote:
> > The included patch fixes the following issues:
> > 1. qla3xxx/qla4xxx co-existence issue which can result in a lockup
when qla3xxx driver is unloaded,
> or when ifdown; ifup is performed on one of the interfaces
correponding to qla3xxx. This is because
> qla4xxx HBA supports one ethernet and iscsi interfaces per port. Both
iscsi and ethernet interfaces
> share the same state machine. The problem has to do with synchronizing
access to the state machine in
> the event of a reset
> > 2. mutex_lock() is sometimes not followed by mutex_unlock() prior to
invoking a msleep() in
> qla4xxx_mailbox_command()
> 
> Git applymbox picked up this nasty (which I've corrected):
> 
> Applying 'qla4xxx: bug fixes'
> 
> Space in indent is followed by a tab.
> .dotest/patch:122:                      set_bit(AF_MBOX_COMMAND,
> &ha->flags);
> Space in indent is followed by a tab.
> .dotest/patch:123:                      mutex_unlock(&ha->mbox_sem);
> Space in indent is followed by a tab.
> .dotest/patch:124:                      break;
> Space in indent is followed by a tab.
> .dotest/patch:125:              }
> Space in indent is followed by a tab.
> .dotest/patch:126:              mutex_unlock(&ha->mbox_sem);
> warning: squelched 7 whitespace errors
> warning: 12 lines add trailing whitespaces.
> 
> James
> 
Sorry about that. Really appreciate your correcting them. 
Thanks
David S.
