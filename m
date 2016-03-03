From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [patch] tcm_loop: use after free on error
Date: Thu, 3 Mar 2016 14:44:06 +0100
Message-ID: <56D83FA6.3000001@redhat.com>
References: <20160302100941.GE5533@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160302100941.GE5533@mwanda>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Sheng Yang <sheng@yasker.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2.3.2016 11:09, Dan Carpenter wrote:
> We dereference "tl_nexus" to get the error code.
>
> Fixes: 1b418a8fcbc0 ('target: Convert demo-mode only drivers to target_alloc_session')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
