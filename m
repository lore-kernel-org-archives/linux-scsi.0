From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 14:50:43 -0400
Message-ID: <yq1efi3bk3g.fsf@oracle.com>
References: <20180522181512.39316-1-keescook@chromium.org>
        <20180522181512.39316-4-keescook@chromium.org>
        <20180522183613.GA3784@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522183613.GA3784@infradead.org> (Christoph Hellwig's
        message of "Tue, 22 May 2018 11:36:13 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> On Tue, May 22, 2018 at 11:15:09AM -0700, Kees Cook wrote:
>> Both SCSI and ATAPI share the sense header. In preparation for using the
>> struct scsi_sense_hdr more widely, move this into a separate header and
>> move the helper function to scsi_ioctl.c which is linked with CONFIG_IDE
>> by way of CONFIG_BLK_SCSI_REQUEST.
>
> Please keep the code where it is and just depend on SCSI on the legacy
> ide driver.  No need to do gymnastics just for a legacy case.

Yup, I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering
