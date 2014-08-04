From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH V3 3/4] Introduce XEN scsiback module
Date: Mon, 4 Aug 2014 13:18:06 +0100
Message-ID: <53DF79FE.5090402@citrix.com>
References: <1407140870-542-1-git-send-email-jgross@suse.com> <1407140870-542-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407140870-542-4-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com, xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 04/08/14 09:27, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Introduces the XEN pvSCSI backend. With pvSCSI it is possible for a XEN domU
> to issue SCSI commands to a SCSI LUN assigned to that domU. The SCSI commands
> are passed to the pvSCSI backend in a driver domain (usually Dom0) which is
> owner of the physical device. This allows e.g. to use SCSI tape drives in a
> XEN domU.

Xen related parts

Acked-by: David Vrabel <david.vrabel@citrix.com>

David
