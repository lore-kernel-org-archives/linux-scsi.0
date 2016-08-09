From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH resend v3 3/5] libata-scsi: use u8 array to store mode
 page copy
Date: Tue, 9 Aug 2016 16:13:49 -0400
Message-ID: <20160809201349.GA25053@mtj.duckdns.org>
References: <CAGnHSEmTC06_NKrBDVyFkLSqx4qDRy+OhXvpcySk6HHYLSRsuw@mail.gmail.com>
 <57926727.840e420a.d7fc9.38dd@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57926727.840e420a.d7fc9.38dd@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, sergei.shtylyov@cogentembedded.com, arnd@arndb.de, sfr@canb.auug.org.au, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 23, 2016 at 02:34:08AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> ata_mselect_*() would initialize a char array for storing a copy of
> the current mode page. However, char could be signed char. In that
> case, bytes larger than 127 would be converted to negative number.
> 
> For example, 0xff from def_control_mpage[] would become -1. This
> prevented ata_mselect_control() from working at all, since when it
> did the read-only bits check, there would always be a mismatch.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.9.

Thanks.

-- 
tejun
