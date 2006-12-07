From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi version 0.19 beta
Date: Thu, 07 Dec 2006 11:50:34 -0500
Message-ID: <4578465A.1070202@torque.net>
References: <4577B06D.6060701@torque.net> <1165508816.4698.2.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032398AbWLGQvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Dec 2006 11:51:15 -0500
In-Reply-To: <1165508816.4698.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2006-12-07 at 01:10 -0500, Douglas Gilbert wrote:
>> The change proposed by James Bottomley that prompted
>> the beta has not materialized.
> 
> You'll have to remind me:  which change was this?

James,
Yes, I'm fuzzy on the details as well. Here is part of
the lsscsi ChangeLog. Do the last two entries ring a bell?

Version 0.19 2006/12/06
  - add transport identifiers (target+initiator, port+node)
  - enhance host name search when proc_name is "<NULL>"
  - implement filter option for '--hosts'
    - accept 'host<n>' as first item in filter to mean host <n>
  - output more host attributes when '-Hll' given
  - add '--list' (or '-L') option output attribute=value
    entries, one per line

Version 0.18 2006/3/24
  - cope with dropping of 'generic' symlink post lk 2.6.16
  - anticipate the future removal of 'tape' symlink

Doug Gilbert

