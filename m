From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvsci: make parameters max_id and max_channel read-only
Date: Wed, 9 Sep 2015 10:33:55 -0500
Message-ID: <55F05163.5000707@linux.vnet.ibm.com>
References: <1441812060-14694-1-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441812060-14694-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laurent Vivier <lvivier@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: dgibson@redhat.com, thuth@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 09/09/2015 10:21 AM, Laurent Vivier wrote:
> The value of the parameter is never re-read by the driver,
> so a new value is ignored. Let know the user he
> can't modify it by removing writable attribute.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
