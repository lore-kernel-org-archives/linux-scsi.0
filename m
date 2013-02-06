From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio-scsi: reset virtqueue affinity when doing
	cpu hotplug
Date: Wed, 06 Feb 2013 18:27:30 +0100
Message-ID: <51129282.7040100@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<50F525E3.1000100@cn.fujitsu.com> <50F52677.80100@cn.fujitsu.com>
	<871udlztui.fsf@rustcorp.com.au> <50F624BA.20208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <50F624BA.20208@cn.fujitsu.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: gaowanlong@cn.fujitsu.com
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

Il 16/01/2013 04:55, Wanlong Gao ha scritto:
>>> >> Add hot cpu notifier to reset the request virtqueue affinity
>>> >> when doing cpu hotplug.
>> > 
>> > You need to be careful to get_online_cpus() and put_online_cpus() here,
>> > so CPUs can't go up and down in the middle of operations.
>> > 
>> > In particular, get_online_cpus()/put_online_cpus() around calls to
>> > virtscsi_set_affinity() (except within notifiers).
> Yes, I'll take care of this, thank you.
> 

I squashed patch 1 (plus changes to get/put_online_cpus) in my
multiqueue series, and applied this one as a separate patch.

Paolo
