From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/6] scsi: cxlflash: Drop unused sense buffers
Date: Tue, 22 May 2018 16:03:06 -0500
Message-ID: <20180522210306.GA60047@p8tul1-build.aus.stglabs.ibm.com>
References: <20180522181512.39316-1-keescook@chromium.org>
 <20180522181512.39316-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180522181512.39316-3-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 22, 2018 at 11:15:08AM -0700, Kees Cook wrote:
> This removes the unused sense buffer in read_cap16() and write_same16().
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Looks good.

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
