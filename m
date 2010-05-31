From: Alexander Graf <agraf@suse.de>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Mon, 31 May 2010 21:18:56 +0200
Message-ID: <2022FC1C-DD55-4AC3-B0D7-FAC2043780CA@suse.de>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>	 <4BECFA39.7040809@suse.de>	 <1273830134.27867.44.camel@haakon2.linux-iscsi.org>	 <1274130584.7348.83.camel@haakon2.linux-iscsi.org>	 <4BF26128.2030400@suse.de>	 <1274181508.7348.181.camel@haakon2.linux-iscsi.org> <1275193534.15413.44.camel@haakon2.linux-iscsi.org> <4C0386D8.4050804@redhat.com>
Mime-Version: 1.0 (iPhone Mail 7E18)
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183Ab0EaTSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2010 15:18:33 -0400
In-Reply-To: <4C0386D8.4050804@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@suse.de>, Avi Kivity <avi@redhat.com>


Am 31.05.2010 um 11:52 schrieb Gerd Hoffmann <kraxel@redhat.com>:

>  Hi,
>
>> Also it's worth mentioning that I am still running C: on QEMU IDE
>> emulation, as I could not quite figure out how to boot for a  
>> megasas LD
>> with option-rom.  What QEMU CLI ops where requried to make this work
>> again..?
>
> -option-rom $file
>
> or
>
> -device megasas,romfile=$file

Or -drive ...,boot=on if you're using qemu-kvm.

Alex

