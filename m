From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: SCSI/ISCSI, hardware/software
Date: Fri, 13 May 2005 16:58:59 -0700
Message-ID: <OF7E993A36.0D88FEC0-ON88257000.0082C701-88257000.0083CAAD@us.ibm.com>
References: <428482A1.5090107@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <428482A1.5090107@vlnb.net>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: David Hollis <dhollis@davehollis.com>, dmitry_yus@yahoo.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sander <sander@humilis.net>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>
List-Id: linux-scsi@vger.kernel.org

>Such iSCSI card from a user point of view as well as for system running 
>on a computer with it is just another SCSI card, not matter which 
>transport it uses and how much software it runs onboard, so for they it 
>doesn't differ from FC or parallel SCSI one, which I think you would not 
>call a software unit.  As usually, you only need appropriate driver for 
>_SCSI_ subsystem.

The point I'd like to make is that _I_ would not call it a software unit 
or a hardware unit, because I don't think in most contexts (including that 
of this thread), it makes any difference which technology is used in the 
implementation.  What _does_ matter is 1) this card comes preassembled.  I 
don't have to find and load independently produced software onto it, or 
worry about interoperability.  2) It's below the Linux kernel, which means 
I won't need to mess with Linux applications or kernels except to load a 
low level SCSI driver.  It also means it doesn't place any load on my main 
CPU and probably goes faster than something implemented in or above my 
Linux kernel would.

And there's the separate point that it would be a misnomer to say that 
this card is an ISCSI initiator (it's only part of one); so even if the 
card itself can be called hardware, that still doesn't mean you can say 
you have a hardware ISCSI initiator.  Same is true of a parallel SCSI host 
adapter card.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems


-------------------------------------------------------
This SF.Net email is sponsored by Oracle Space Sweepstakes
Want to be the first software developer in space?
Enter now for the Oracle Space Sweepstakes!
http://ads.osdn.com/?ad_id=7393&alloc_id=16281&op=click
