From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?=
        <kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: remove redundant pointer STbuffer
Date: Sun, 5 Aug 2018 12:14:32 +0300
Message-ID: <5FB12D0E-73B3-4A5B-BAB8-7D3DF7979EF1@kolumbus.fi>
References: <20180803104752.17081-1-colin.king@canonical.com>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803104752.17081-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> On 3 Aug 2018, at 13.47, Colin King <colin.king@canonical.com> wrote:
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer STbuffer is being assigned but is never used hence it is
> redundant and can be removed.
> 
> Cleans up clang warning:
> warning: variable 'STbuffer' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

Has been unused at least since 2005 :-)

Thanks,
Kai
