From: <David_Papasan@Dell.com>
Subject: Request for information: Infamous Ext3_Inode errors on Adaptec Perc 3/di
Date: Tue, 25 May 2004 09:00:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <633B61B5AD33AE4AA627928D464A98B9039AF3AD@ausx2kmps306.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:22862 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S264850AbUEYOA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2004 10:00:28 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-poweredge@dell.com, linux-scsi@vger.kernel.org

All,
 
We have been working for a while now on tracking down and fixing this
issue. 
 
Summary of the issue:
Systems running Adaptec ROMB ( 3/di) with otherwise healthy arrays.
System gets Ext3_Inode errors on the console, and looses connection to
the disks. Normally the logs do not have the errors, only the console
due to not being able to write to the disk.
 
Not part of the issue:
Filesystem errors when the array drops offline, or multiple disks
failed,  or there is pre-existing filesystem corruptions. 
 
We believe we have identified the problem causing the error but I would
like to get a larger sample to make sure we don't have any corner cases
missed.
 
If you have (or had) the problem and can provide the answers to a few
questions it would be appreciated. To keep from spamming the lists you
can send the mail directly to me with " Ext3_Inode errors on Adaptec
Perc 3/di " in the subject.
 
Questions:
1.) How many CPU's in the system?
        a.) is Hyper Threading turned on ? 
        b.) have any CPU's or HT been disabled ?
 
2.) Is the ROMB battery present and working ?
    a.) is write cache enabled and on for the arrays ? ( from afacli you
can view this by doing a container show cache X where X is the container
number. You want to check the setting and status. ie Enabled when
protected, )
    b.) has the system been run with cache disabled or the ROMB battery
removed ?
 
3.) Do the errors occur at a particular time of day, or on a pattern in
time. Ie 15 min. after the hour, Noon, midnight Sundays
    a.) What if any load or cron jobs are running at the time of
failure.
 
General ramblings, other things you did that did/didn't work etc. :
 
 
 
David Papasan

