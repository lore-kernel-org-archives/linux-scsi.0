From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 03:13:49 -0500
Message-ID: <4CE38EBD.2040606@garzik.org>
References: <20101117062958.GA2894@havoc.gtf.org> <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com> <4CE38D70.4010507@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CE38D70.4010507@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/17/2010 03:08 AM, Jeff Garzik wrote:
> So maybe an EH expert (Tejun?) can correct me here, but I think we may
> be able to completely the lock/get-serial/unlock sequence from libata,
		^^^ er, completely remove

