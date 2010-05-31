From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Mon, 31 May 2010 11:52:24 +0200
Message-ID: <4C0386D8.4050804@redhat.com>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>	 <4BECFA39.7040809@suse.de>	 <1273830134.27867.44.camel@haakon2.linux-iscsi.org>	 <1274130584.7348.83.camel@haakon2.linux-iscsi.org>	 <4BF26128.2030400@suse.de>	 <1274181508.7348.181.camel@haakon2.linux-iscsi.org> <1275193534.15413.44.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1275193534.15413.44.camel@haakon2.linux-iscsi.org>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Hannes Reinecke <hare@suse.de>, kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@suse.de>, Avi Kivity <avi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

   Hi,

> Also it's worth mentioning that I am still running C: on QEMU IDE
> emulation, as I could not quite figure out how to boot for a megasas LD
> with option-rom.  What QEMU CLI ops where requried to make this work
> again..?

-option-rom $file

or

-device megasas,romfile=$file

cheers,
   Gerd

