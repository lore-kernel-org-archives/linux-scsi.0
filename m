From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Date: Wed, 9 Jul 2014 01:41:54 -0700
Message-ID: <20140709084154.GC6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404866812-26950-3-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> +	if ((vmbus_proto_version == VERSION_WS2008) ||
> +	     (vmbus_proto_version == VERSION_WIN7)) {

This has superflous braces and doesn't use proper Linux indentation.

But I think simply using a switch here might be cleaner anyway.
