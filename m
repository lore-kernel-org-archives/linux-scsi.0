From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] gdth: Fixup section annotations
Date: Mon, 13 Jan 2014 16:12:13 +0000
Message-ID: <1389629533.12062.5.camel@dabdike.int.hansenpartnership.com>
References: <1389367888-117607-1-git-send-email-hare@suse.de>
	 <1389373643.4066.0.camel@dabdike> <52D3A294.2040108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:54629 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaAMQMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jan 2014 11:12:19 -0500
In-Reply-To: <52D3A294.2040108@suse.de>
Content-Language: en-US
Content-ID: <3A20F7018CA9B542879D9D13068D3ED2@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2014-01-13 at 09:23 +0100, Hannes Reinecke wrote:
> On 01/10/2014 06:07 PM, James Bottomley wrote:
> > On Fri, 2014-01-10 at 16:31 +0100, Hannes Reinecke wrote:
> >> Fixup section annotations so that kbuild doesn't complain anymore.
> > 
> > This doesn't look right: __devinit is now an obsolete annotation.
> > 
> Hmm. Patch has been in our internal kernel repository for ages.
> I'll be checking.

We fixed all the __dev section horrors by simply eliminating
CONFIG_HOTPLUG.  After that, the compiler and linker should notice
sectional problems (basically around init and exit sections), so either
the patch is obsolete, or there is some residue after all the __dev...
sections are removed that is still needed.

James

