From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata, SCSI and storage drivers
Date: Fri, 27 May 2005 14:05:26 -0400
Message-ID: <42976166.3090508@pobox.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC3D@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201AC3D@xbl3.ad.emulex.com>
Sender: linux-ide-owner@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, dougg@torque.net, axboe@suse.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
> Folks,
> 
> This discussion brings up some latent questions...
> 
> The transport can be a subsystem on it's own and is perhaps independent
> of SCSI altogether. In this case, SCSI just happens to be a personality
> of something on the transport. This is at odds with the current design
> in which the transport is something under SCSI and inherently bound to
> the SCSI "host".

Yes.  This is something I really want to change, for libata.


> I understand how we got to where we are, but shouldn't we consider making
> some transports independent subsystems ? If the only protocol that
> can be run on the transport is SCSI (ex: SPI), then the transport can be
> under SCSI. However, if the transport can support multiple protocols (FC
> can support SCSI, IP, (or ATA)), shouldn't it be structured more like an io
> bus like pci ? 

Unfortunately this is an open-ended question that Linux is rather poor 
at answering, since the answer could range from "no" to "show me the 
code" to "you're an absolute visionary!"  :)

My own opinion:

I consciously avoid thinking too much in that direction.  Linux 
development is a lot like a biological process.  The evolution of the 
kernel code over time will give us the best answer.

Perhaps we will merge request_queue and network stack systems into a 
single "packet transport" system.  Perhaps net stack and request_queue 
systems will stay separate, and request_queue will evolve into a 
generalized system for RPC message transport.

With the device model, both IDE [as of yesterday] and SCSI -already- 
export bus topology in a standardized manner, just like PCI.

	Jeff


