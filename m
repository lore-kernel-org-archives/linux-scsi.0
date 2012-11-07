From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH 0/5] virtio-scsi: create a separate workqueue
Date: Thu, 08 Nov 2012 07:38:51 +0800
Message-ID: <509AF10B.1060100@cn.fujitsu.com>
References: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <819170817.7936726.1352326332306.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2012 06:12 AM, Paolo Bonzini wrote:
>> patch 1-3,5 are some cleanups.
>> patch 4: create a separate work queue for virtio-scsi
>> to improve the performance, I tested with tmpfs backed
>> disk, the config file is like below,
> 
> I think something else caused the improvement, because the code you
> touched (complete_event) shouldn't ever run during a normal benchmark.
> It's only used for hotplug/hot-unplug.
> 
> Nevertheless, I'll queue the cleanup patches.  Thanks for those.

Oops, got it, I will investigate more. Thank you for teaching me.

Regards,
Wanlong Gao
