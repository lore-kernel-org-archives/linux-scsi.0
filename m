From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: Controlling PATA access speeds
Date: Thu, 01 Jun 2006 16:21:58 -0500
Message-ID: <200606012121.k51LLwCa009141@falcon10.austin.ibm.com>
References: <BAY113-F2199B8BEE31723E17D24CCDF900@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <BAY113-F2199B8BEE31723E17D24CCDF900@phx.gbl> 
Sender: linux-ide-owner@vger.kernel.org
To: John Treubig <jtreubig@hotmail.com>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 01 Jun 2006 15:35:23 CDT, "John Treubig" wrote:
>Jeff,
>
>You bring up a good point in the fact that I believe your refering to 
>detecting 80 wire vs. 40 wire.  We've not tried to use this to our 
>advantage, but it could have some merrit.  What does the driver do if it 
>encounters a 40 wire cable and the drive says it's capable of DMA5?
>

The presence of a 40 wire cable limits the device to UDMA2 - 33mhz.  
See the ATA6 or later on t13.org.

JS20 blades are lackinging the strapping to indicate the devices hanging 
off the amd8111 are on the equivalent of 80 wire - 4 inch trace on mb.
In the JS20 case, a quirk will be necessary to run at speeds higher than UDMA2.

++doug


