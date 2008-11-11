From: Keith Owens <kaos@ocs.com.au>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 13:09:38 +1100
Message-ID: <28572.1226369378@ocs10w>
References: <9FA859626025B64FBC2AF149D97C944A8A64B5@CORPUSMX80A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: Your message of "Mon, 10 Nov 2008 20:23:17 CDT."
             <9FA859626025B64FBC2AF149D97C944A8A64B5@CORPUSMX80A.corp.emc.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Black_David@emc.com
Cc: david@fromorbit.com, dwmw2@infradead.org, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

On Mon, 10 Nov 2008 20:23:17 -0500, 
Black_David@emc.com wrote:
>Dave,
>The thin provisioning chunk size (coming) in the VPD page is a
>possible place to start.

VPD page for which device?  Consider a filesystem that is striped
across devices from multiple arrays or even multiple vendors.  How is
the filesystem supposed to "align" an unmap command when the underlying
disks all have different alignments?

