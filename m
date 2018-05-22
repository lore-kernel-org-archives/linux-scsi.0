From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/6] block: Create scsi_sense.h for SCSI and ATAPI
Date: Tue, 22 May 2018 13:16:54 -0600
Message-ID: <8d4af5c4-96fa-54ee-d5c1-b887b1de5a3c@kernel.dk>
References: <20180522181512.39316-1-keescook@chromium.org>
 <20180522181512.39316-4-keescook@chromium.org>
 <20180522183613.GA3784@infradead.org> <yq1efi3bk3g.fsf@oracle.com>
 <CAGXu5jJ0Sice+fdpWgzBhQR=NGz-DT9qmYVdV1GeH73_q9pbmw@mail.gmail.com>
 <732f4249-5681-4a54-ec21-4ecc3d3a74e5@kernel.dk>
 <20180522191309.GA23615@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180522191309.GA23615@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block <linux-block@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 5/22/18 1:13 PM, Christoph Hellwig wrote:
> On Tue, May 22, 2018 at 01:09:41PM -0600, Jens Axboe wrote:
>> I think Martin and Christoph are objecting to moving the code to
>> block/scsi_ioctl.h. I don't care too much about where the code is, but
>> think it would be nice to have the definitions in a separate header. But
>> if they prefer just pulling in all of SCSI for it, well then I guess
>> it's pointless to move the header bits. Seems very heavy handed to me,
>> though.
> 
> It might be heavy handed for the 3 remaining users of drivers/ide,

Brutal :-)

> but as long as that stuff just keeps working I'd rather worry about
> everyone else, and keep the scsi code where it belongs.

Fine with me then, hopefully we can some day kill it off.

-- 
Jens Axboe
