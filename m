From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v2] xen/scsifront: don't request a slot on the ring until
 request is ready
Date: Thu, 8 Dec 2016 09:56:44 -0500
Message-ID: <a38a0e53-2ac2-d0ed-93b4-cf5cc0d8b66d@oracle.com>
References: <20161125202650.GK6266@mwanda>
 <20161202061545.14614-1-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161202061545.14614-1-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: lambert.quentin@gmail.com, linux-scsi@vger.kernel.org, dan.carpenter@oracle.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org



On 12/02/2016 01:15 AM, Juergen Gross wrote:
> Instead of requesting a new slot on the ring to the backend early, do
> so only after all has been setup for the request to be sent. This
> makes error handling easier as we don't need to undo the request id
> allocation and ring slot allocation.
>
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

(although it would be good to have someone familiar with this code look 
at this as well).
