From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] xen/scsifront: don't request a slot on the ring until
 request is ready
Date: Fri, 9 Dec 2016 11:13:34 +0100
Message-ID: <f8632b39-e793-1e8a-990c-5d612fbdb7b0@suse.com>
References: <20161125202650.GK6266@mwanda>
 <20161202061545.14614-1-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161202061545.14614-1-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, lambert.quentin@gmail.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 02/12/16 07:15, Juergen Gross wrote:
> Instead of requesting a new slot on the ring to the backend early, do
> so only after all has been setup for the request to be sent. This
> makes error handling easier as we don't need to undo the request id
> allocation and ring slot allocation.
> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>


Commited to xen/tip.git for-linus-4.10


Juergen
