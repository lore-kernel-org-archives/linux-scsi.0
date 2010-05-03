From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
 for scsi device(This is correct revision, please ignore last one)
Date: Mon, 03 May 2010 08:59:45 -0400
Message-ID: <1272891585.4369.15.camel@mulgrave.site>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
Sender: linux-kernel-owner@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-05-03 at 15:45 +0800, Nick Cheng wrote:
> 1. To support instantaneous report for SCSI device existing by period=
ic
> polling
> 2. In arcmsr_iop_xfer(), inform AP of F/W's deadlock state to prevent
> endless waiting
> 3. To block the coming SCSI command while the driver is handling bus =
reset
> 4. To support HW reset in bus reset error handler
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

This patch still isn't compiling:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_hba.c: In function =E2=80=98arcmsr_pci_slot_=
reset=E2=80=99:
drivers/scsi/arcmsr/arcmsr_hba.c:2733: error: too few arguments to
function =E2=80=98arcmsr_get_firmware_spec=E2=80=99
make[1]: *** [drivers/scsi/arcmsr/arcmsr_hba.o] Error 1
make: *** [drivers/scsi/arcmsr/arcmsr.ko] Error 2

It looks like you missed converting one of the
arcmsr_get_firmware_spec() to the two argument prototype.

James
