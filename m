From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V1 1/7] Drivers: hv: vmbus: Implement multi-channel
 support
Date: Thu, 16 May 2013 10:01:13 -0400
Message-ID: <20130516140113.GB2629@kroah.com>
References: <1368706784-32276-1-git-send-email-kys@microsoft.com>
 <1368706879-32321-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368706879-32321-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, May 16, 2013 at 05:21:13AM -0700, K. Y. Srinivasan wrote:
> Starting with Win8, the host supports multiple sub-channels for a given
> device. As in the past, the initial channel offer specifies the device and
> is associated with both the type and the instance GUIDs. For performance
> critical devices, the host may support multiple sub-channels. The sub-channels
> share the same type and instance GUID as the primary channel. The number of
> sub-channels offerrred to the guest depends on the number of virtual CPUs
> assigned to the guest. The guest can request the creation of these sub-channels
> and once created and opened, the guest can distribute the traffic across all
> the channels (the primary and the sub-channels). A request sent on a sub-channel
> will have the response delivered on the same sub-channel.
> 
> At channel (sub-channel) creation we bind the channel interrupt to a CPU and
> with this sub-channel support we will be able to spread the interrupt load
> of a given device across all available CPUs.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
