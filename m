From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi_ram: a RAM-based SCSI driver
Date: Thu, 06 Dec 2012 11:09:07 +0100
Message-ID: <50C06EC3.20002@redhat.com>
References: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354725918-14713-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <willy@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 05/12/2012 17:45, Kirill A. Shutemov ha scritto:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> This driver is intended to run as fast as possible, hence the options to
> discard writes and reads. It's designed to let us find latency issues
> elsewhere in the storage stack (eg filesystem, block layer, scsi layer).
> 
> There are a few different options, controlled through module parameters.
> The sector size and disc capacity are load-time parameters, but the
> parameters affecting performance are tweakable at runtime.
> 
> By default, it'll allocate half a gigabyte of RAM to use as a ramdisc;
> you can change this with the `capacity' module parameter.

Is this that much faster than scsi-debug?  The discarding options surely
can be added there.

Paolo
