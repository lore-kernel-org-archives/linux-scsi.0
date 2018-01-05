From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 0/5] Introduce sgl_alloc() and sgl_free()
Date: Fri, 5 Jan 2018 12:49:26 -0700
Message-ID: <a5f80b53-397b-057e-d2c2-5b132982d83a@kernel.dk>
References: <20180105162650.31083-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180105162650.31083-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On 1/5/18 9:26 AM, Bart Van Assche wrote:
> Hello Jens,
> 
> As you know there are multiple drivers that both allocate a scatter/gather
> list and populate that list with pages. This patch series moves the code for
> allocating and freeing such scatterlists from several drivers into
> lib/scatterlist.c. Please consider this patch series for kernel v4.16.

Thanks Bart, applied for 4.16.

-- 
Jens Axboe
