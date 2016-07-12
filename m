From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 2/2] libata-scsi: avoid repeated calculation of number
 of TRIM ranges
Date: Tue, 12 Jul 2016 15:12:21 -0400
Message-ID: <20160712191221.GB10377@htj.duckdns.org>
References: <20160706171906.1993-1-me>
 <577d3d99.24f0420a.c2bbd.ffffd427@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <577d3d99.24f0420a.c2bbd.ffffd427@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Jul 07, 2016 at 01:19:06AM +0800, tom.ty89@gmail.com wrote:
> @@ -1071,7 +1072,7 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer,
>  	__le64 *buffer = _buffer;
>  	unsigned i = 0, used_bytes;
>  
> -	while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
> +	while (i < buf_size) {

Please rename @buf_size.  It's confusing for a variable named size to
contain something other than bytes.

Thanks.

-- 
tejun
