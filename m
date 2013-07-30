From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: [SCSI REGRESSION] 3.10.2 or 3.10.3: arcmsr failure at bootup
 / early userspace transition
Date: Tue, 30 Jul 2013 20:14:44 +0200
Message-ID: <51F80294.50804@fastmail.fm>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm> <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm> <87fvuxdqes.fsf@spindle.srvr.nix> <51F708A4.9090207@interlog.com> <87ob9koogb.fsf@spindle.srvr.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87ob9koogb.fsf@spindle.srvr.nix>
Sender: stable-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, nick.cheng@areca.com.tw, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/30/2013 02:56 AM, Nix wrote:
> On 30 Jul 2013, Douglas Gilbert outgrape:
>
>> Please supply the information that Martin Petersen asked
>> for.
>
> Did it in private IRC (the advantage of working for the same division of
> the same company!)
>
> I didn't realise the original fix was actually implemented to allow
> Bernd, with a different Areca controller, to boot... obviously, in that
> situation, reversion is wrong, since that would just replace one won't-
> boot situation with another.

Unless there is very simple fix the commit should reverted, imho. It 
would better then to remove write-same support from the md-layer.


Cheers,
Bernd
