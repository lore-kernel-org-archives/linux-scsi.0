From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from iface.
Date: Wed, 14 Jun 2017 10:47:57 -0600
Message-ID: <CAANLjFqSB=JuaLJ1Ax-L9B0m-6EW6Hk9ePXGY-pMCK0uKJ6h_Q@mail.gmail.com>
References: <20170606180717.5007-1-robert@leblancnet.us> <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
 <CAANLjFomYCEmjfE7HLAsE7SgVqBKH8KSxYzFqxuV7t8as8+-ZQ@mail.gmail.com>
 <CAANLjFrJ2g8JfB-3bcVwVXxK41rB3aaSeP3ho7J5F0YLO=3sUw@mail.gmail.com> <D566FD10.3ABC0%manish.rangankar@cavium.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCE4FWGB4QCRBPWRQXFAKGQEHCMXEZA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <D566FD10.3ABC0%manish.rangankar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: "Rangankar, Manish" <Manish.Rangankar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "lduncan-IBi9RG/b67k@public.gmane.org" <lduncan-IBi9RG/b67k@public.gmane.org>, "jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org" <jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Dept-Eng
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 14, 2017 at 3:20 AM, Rangankar, Manish
<Manish.Rangankar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>
> On 13/06/17 10:19 PM, "Robert LeBlanc" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>
>>On Wed, Jun 7, 2017 at 12:30 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
>>wrote:
>>> On Wed, Jun 7, 2017 at 10:28 AM, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On Tue, Jun 06, 2017 at 12:07:10PM -0600, Robert LeBlanc wrote:
>>>>> This patchset enables iSCSI offload drivers to have access to the
>>>>>iface
>>>>> information provided by iscsid. This allows users to have more control
>>>>> of how the driver connects to the iSCSI target. iSER is updated to use
>>>>> iface.ipaddress to set the source IP address if configured. This
>>>>>allows
>>>>> iSER to use multiple ports on the same network or in more complicated
>>>>> routed configurations.
>>>>>
>>>>> Since there is already a change to the function parameters, dst_addr
>>>>> is upgraded to sockaddr_storage so that it is more future proof and
>>>>>makes
>>>>> the size of the struct static and not dependent on checking the
>>>>>SA_FAMILY.
>>>>>
>>>>> This is dependent on updates to Open-iSCSI.
>>>>
>>>> Hi Robert,
>>>>
>>>> I don't think that passing the iface_rec structure directly from the
>>>> iscsid internals into a netlink message is a good way to go about this.
>>>> It's really big, there's an embedded list_head with user address
>>>> pointers that needs to be left out, and there are 32/64-bit layout
>>>> differences.
>>>>
>>>> Let me take a look at how you're proposing using this info for iSER, if
>>>> it makes sense I think we should come up with a better designed
>>>> structure for passing the information.
>>>>
>>>> Thanks,
>>>> Chris
>>>>
>>>
>>> Chris,
>>>
>>> Thank you for your feedback. I agree that the entire iface is probably
>>> overkill, it was more of a proof of concept. We are only using the
>>> ipaddress in the iface for iSER (in my patch), but I could see other
>>> drivers benefiting from some of the other data in the iface (mac,
>>> interface_name, vlan, etc) so I didn't want to be too restrictive so
>>> that it wouldn't have to be extended later. I've not worked on
>>> userspace/kernel interaction before so I need some guidance to make
>>> the transition between userspace and kernel versions smoother.
>>>
>>> This patchset works for what we need and it is very important for us
>>> (and I'm sure others once the feature is available) and I'm happy to
>>> put in the time to get it accepted upstream, I'm just new to kernel
>>> development and need some guidance.
>>
>>Are there other comments/ideas/suggestions specifically from the
>>iSCSI/iSER guys? I'd like to keep this patch moving.
>
> Considering partial iSCSI offload solution (like bnx2i and qedi) point of
> view, we liked the idea from Hannes to create TAP interface to associate
> with each iSCSI offload interface, which will allow us to use userspace
> tools for configuration. I haven't dig into its details yet, but at higher
> level it looks like this will help us to move away from our dependency
> over iscsiuio.

I'm having a hard time wrapping my head around this idea. How can
configuring a TAP (separate Ethernet device) affect the offload NIC. I
don't see how you can bind to the right interface with the IP address
or how that is passed to rdma_connect() using a TAP. Is TAP used
instead of netlink for communicating between userspace and the kernel?
Obviously by my questions, at the moment I'm not sure how to approach
this at all and would be the wrong person to make this happen.

If someone can explain how this would work and point to some code that
does something like this (examples are good for me), I can try to
create a patch with TAPs. As I mentioned before, this is important for
us and I'm willing to put in the time to learn and code, but I'm
really lost at this point.

Thank you,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
