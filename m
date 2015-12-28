From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 0/4] scsi: cleanup ioctl headers and provide UAPI
 versions
Date: Tue, 29 Dec 2015 00:27:54 +0100
Message-ID: <5681C57A.8030200@redhat.com>
References: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443173264-4105-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: bart.vanassche@sandisk.com, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 25/09/2015 11:27, Paolo Bonzini wrote:
> This is v3 of the series to provide an "official" sg.h header (and
> scsi_ioctl.h too, though it's basically obsolete) together with the other
> userspace API definitions.  The change from v2 to v3 is that defaults
> for sg.c are not exported in include/uapi/linux/sg.c.
> 
> Paolo
> 
> 2.5.0
> 

What happened to these patches?...

Paolo
