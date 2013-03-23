From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH V6 5/5] virtio-scsi: reset virtqueue affinity when doing
	cpu hotplug
Date: Sat, 23 Mar 2013 07:36:30 +0100
Message-ID: <514D4D6E.4000303@redhat.com>
References: <1363762884-11000-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<1363762884-11000-6-git-send-email-gaowanlong@cn.fujitsu.com>
	<20130320072425.GA23182@hj.localdomain>
	<51496BAF.2030202@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <51496BAF.2030202@cn.fujitsu.com>
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
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, JBottomley@parallels.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 20/03/2013 08:56, Wanlong Gao ha scritto:
>> This one does not apply on top of virtio-next + patch 1-4 in this series.
> 
> I'm very sorry.
> 
> This fault is because I modified the 4/5 from 
> "/* if the affinity hint is set for virtqueues */"
> to
> "/* If the affinity hint is set for virtqueues */"
> by hand.
> 
> You can also change "If" to "if" in 5/5 to apply this patch without 3-way merge.

Can you respin?

So we can ask James for his Acked-by and get this merged in the next window.

Paolo
