From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: scsi-mq + open-iscsi support patches..?
Date: Fri, 01 Nov 2013 09:46:23 -0500
Message-ID: <5273BEBF.2090008@cs.wisc.edu>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBRX5Z2JQKGQEOSTP7TI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1382997816.19256.767.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/28/13 5:03 PM, Nicholas A. Bellinger wrote:
> Hi Mike,
>
> Just curious as to the status of the scsi-mq conversion patches for
> open-iscsi that you where working on a while back..?
>
> I'm asking because recently I've been spending alot of time with scsi-mq
> + virtio-scsi, and would really to start banging on iser-target ports
> using an scsi-mq enabled iser-initiator as well..
>
> So that said, are there any blockers holding things up towards getting a
> working prototype..?
>

Just time. Just finished a release at work and just got back from 
vacation so hoping to work on this some more in the next weeks.

On a related note, some iscsi vendor has been hitting a crash with your 
tree. Have you rebased it it to take in Christoph's changes and fixes 
that are in Jens's tree? The code here

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/log/?h=scsi-mq

looks ok. That is the current code right?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/groups/opt_out.
