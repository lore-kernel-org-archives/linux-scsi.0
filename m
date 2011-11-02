From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: blk_make_request() returns an ERR_PTR()
Date: Wed, 02 Nov 2011 08:51:50 -0700
Message-ID: <1320249110.1261.27.camel@haakon2.linux-iscsi.org>
References: <20111031070315.GA13640@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111031070315.GA13640@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-31 at 10:03 +0300, Dan Carpenter wrote:
> The check is wrong here because blk_make_request() returns an
> ERR_PTR() and it doesn't return NULL.
> 
> 

Applied and queuing for the next pull.  Thanks Dan!

--nab
