From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/8] libata: use the enlarged capacity after late HPA
 unlock
Date: Sat, 15 May 2010 15:22:15 -0400
Message-ID: <4BEEF467.9030300@garzik.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-8-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-8-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On 05/15/2010 02:09 PM, Tejun Heo wrote:
> After late HPA unlock, libata kept using the original capacity
> ignoring the new larger native capacity.  Enlarging device on the fly
> doesn't cause any harm.  Use the larger native capacity instead.  This
> will enable on-demand HPA unlocking.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Ben Hutchings<ben@decadent.org.uk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


