From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build failure after merge of the scsi tree
Date: Fri, 11 Jan 2013 07:34:16 +0000
Message-ID: <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-01-11 at 12:03 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/ipr.c:9138:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_enable_msix'
> drivers/scsi/ipr.c:9165:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_enable_msi'
> drivers/scsi/ipr.c:9188:23: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'name_msi_vectors'
> drivers/scsi/ipr.c:9200:22: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'ipr_request_other_msi_irqs'
> drivers/scsi/ipr.c: In function 'ipr_probe_ioa':
> drivers/scsi/ipr.c:9422:4: error: implicit declaration of function 'ipr_enable_msix' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9425:4: error: implicit declaration of function 'ipr_enable_msi' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9517:3: error: implicit declaration of function 'name_msi_vectors' [-Werror=implicit-function-declaration]
> drivers/scsi/ipr.c:9523:4: error: implicit declaration of function 'ipr_request_other_msi_irqs' [-Werror=implicit-function-declaration]

OK, fine, I'll drop all the ipr patches.  I've been waiting for a month
for them to fix the smatch and sparse warnings.  Please resend the
series with all the fixes.

Thanks,

James
