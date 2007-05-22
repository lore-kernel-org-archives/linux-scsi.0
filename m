From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Sg_ses question
Date: Tue, 22 May 2007 16:29:15 -0400
Message-ID: <4653529B.9080100@torque.net>
References: <861B5CF71BC70C478DFEB9EAFE98F6990233CAA7@G3W0068.americas.hpqcorp.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXEVUeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 16:34:12 -0400
In-Reply-To: <861B5CF71BC70C478DFEB9EAFE98F6990233CAA7@G3W0068.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>
Cc: linux-scsi@vger.kernel.org

Haefliger, Juerg wrote:
> Hi,
> 
> Not sure if this is the right list for my question but I couldn't find a
> more suitable place to ask it.
> 
> I'm trying to set the locator light of a disk in a SAS enclosure using
> sg_ses but I'm not getting anywhere. I'm dumping the enclosure status
> diagnostic page using 'sg_ses --page=2 --raw /dev/sgXX > page' and then
> set the SELECT and RQST IDENT bits of the array device element in
> question and write it back doing 'sg_ses --control --page=2 --data=-
> /dev/sgXX < tmp'. The command completes without error but unfortunately,
> nothing happens. When I read the page back, the IDENT bit is still
> cleared and the light on the enclosure remains turned off.
> 
> Am I doing something wrong or am I missing something? Can't I use sg_ses
> to achieve this?

The procedure looks correct. I haven't had any (other)
reports of sg_ses not working lately. The only suggestion
I can make is to ask if you have selected the element
control rather than the overall control.

Doug Gilbert




