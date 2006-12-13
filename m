From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: What is Target Mode in SATA terminology?
Date: Wed, 13 Dec 2006 21:09:36 +0300
Message-ID: <458041E0.2010408@vlnb.net>
References: <1160423279.27817.4.camel@home-desk> <200610092215.20396.jli@greshamstorage.com> <20061010035842.GA10086@lsil.com> <200610100926.08656.jli@greshamstorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([85.249.135.243]:36296 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964900AbWLMSkR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Dec 2006 13:40:17 -0500
In-Reply-To: <200610100926.08656.jli@greshamstorage.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jli@greshamstorage.com>
Cc: Eric Moore <eric.moore@lsil.com>, Sean Bruno <sean.bruno@dsl-only.net>, linux-scsi@vger.kernel.org, erikhabbinga@inphase-tech.com

Jeremy Linton wrote:
> On Monday 09 October 2006 22:58, Eric Moore wrote:
> 
>>On Mon, Oct 09, 2006 at 10:15:20PM -0500, Jeremy Linton wrote:
>>
>>>>Is there an equivalent in SATA / SAS land?  If there is, is there a
>>>>well supported PCI-(E/X) board out there that I could play with?
>>>
>>>	Well, the MPT driver for scst should support SAS. I can tell you though
>>>that the MPT driver isn't exactly stable for SPI..
>>>-
>>
>>As far as I know, there are no scst target mode drivers for fusion.  Or are
>>there? I've not heard of anyone doing that so far.
> 
> 	One of the scst project members has a port of some LSI MPT target drivers to 
> scst. They are here http://bj.soulinfo.com/%7Ehugang/scst/tgt/. I've been 
> trying to get them working with a 53c1030 series LVD card and they don't get 
> past exporting basic inquiry data. The contact for the drivers hasn't 
> responded to any of my email's either, and the main project doesn't support 
> them.

If you are still interested in SCSI target mode driver for fusion, you
can take a look at the new version of the Hu Gang's driver, developed by
Erik Habbinga, which is just made available from SCST SVN. You can get
anonymous access there using:

svn co https://svn.sourceforge.net/svnroot/scst

Vlad
