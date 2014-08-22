From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH V5 2/5] Add XEN pvSCSI protocol description
Date: Fri, 22 Aug 2014 11:52:14 +0100
Message-ID: <53F720DE.1060702@citrix.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com> <1408354310-6362-3-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1408354310-6362-3-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On 18/08/14 10:31, jgross@suse.com wrote:
> - add support for larger SG-lists by putting them in an own granted page

As a reminder, this can't be acked until this protocol change has been
applied to Xen copy of this header.

David
