From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Random scsi disk disappearing
Date: Wed, 07 Feb 2007 23:26:13 -0500
Message-ID: <45CAA665.1030102@torque.net>
References: <20060818091139.GA6120@lion28.ibm.com> <20070207164148.961d4c70.randy.dunlap@oracle.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37714 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030661AbXBHE0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 23:26:40 -0500
In-Reply-To: <20070207164148.961d4c70.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andreas Herrmann <aherrman@de.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Linux SCSI <linux-scsi@vger.kernel.org>, berthiaume_wayne@emc.com

Randy Dunlap wrote:
> [lkml dropped]  [old thread]
> 
> On Fri, 18 Aug 2006 11:11:39 +0200 Andreas Herrmann wrote:
> 
>> On 18.08.2006 00:33 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>>> Andreas Herrmann wrote:
>>>> Anyone interested in a script to conveniently interpret or change the
>>>> SCSI logging level? Such a script (scsi_logging_level) exists in the
>>>> s390-tools package (version 1.5.3).
>>> That would be very welcome.
> 
> Hi Doug,
> 
> Did you give any thought to adding this script (or a current version
> of it, from
> http://www-128.ibm.com/developerworks/linux/linux390/s390-tools-1.5.4.html)
> to sg3-utils?  or would you give it some thought?
> 
> I think that's a better solution than adding to the kernel tree
> (and better than getting it from developerworks :).
> 
> Thanks.

Randy,
The recently released sg3_utils version 1.23 contains
a "scripts" directory. The files in there are:
  README
  sas_disk_blink
  scsi_logging_level
  scsi_mandat
  scsi_readcap
  scsi_ready
  scsi_satl
  scsi_start
  scsi_stop
  scsi_temperature

Does one look familiar?
If there is a later version, I can put it in sg3_utils-1.24 .

Doug Gilbert
