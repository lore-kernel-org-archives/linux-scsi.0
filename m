From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/6] virtio-scsi patches for 3.16 + midlayer fix
Date: Wed, 04 Jun 2014 13:33:04 +0200
Message-ID: <538F03F0.8050506@redhat.com>
References: <1401876703-10236-1-git-send-email-pbonzini@redhat.com> <538F0127.9040300@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <538F0127.9040300@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

Il 04/06/2014 13:21, Bart Van Assche ha scritto:
>
> Thanks for the quick respin. However, since you are mentioning that in
> v2 all occurrences of "scmd->result |= DID_TIME_OUT << 16" have been
> addressed, this made me wonder whether you had noticed the following
> code in scsi_decide_disposition() ?
>
> 	switch (host_byte(scmd->result)) {
> 	[ ... ]
> 	case DID_ABORT:
> 		if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
> 			scmd->result |= DID_TIME_OUT << 16;
> 			return SUCCESS;
> 		}

Nope, I miscounted how many occurrences were left.  v3 on the way.

Paolo
