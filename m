From: Lee Duncan <leeman.duncan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] scsi: iscsi_tcp: set BDI_CAP_STABLE_WRITES when data digest enabled
Date: Thu, 15 Mar 2018 04:37:24 -0600
Message-ID: <8FA9AB3F-DFD0-4DB9-B1F3-0C1049E4A2E5@gmail.com>
References: <1520425743-1923-1-git-send-email-jianchao.w.wang@oracle.com> <yq137129dvi.fsf@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBC755V5RXMKBBZ4ZVHKQKGQEKEVHWOA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <yq137129dvi.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jianchao Wang <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

I reviewed this several days before but mistakenly replied only to the open-iscsi list. 

Signed-off-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>

--
Lee-Man Duncan
Sent from my iPhone, dude


> On Mar 14, 2018, at 10:11 PM, Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> 
>> iscsi tcp will first send out data, then calculate and send data
>> digest. If we don't have BDI_CAP_STABLE_WRITES, the page cache will
>> be written in spite of the on going writeback. Consequently, wrong
>> digest will be got and sent to target.
>> 
>> To fix this, set BDI_CAP_STABLE_WRITES when data digest is enabled
>> in iscsi_tcp .slave_configure callback.
> 
> Lee, Chris: Please review!
> 
> -- 
> Martin K. Petersen    Oracle Linux Engineering
> 
> -- 
> You received this message because you are subscribed to a topic in the Google Groups "open-iscsi" group.
> To unsubscribe from this topic, visit https://groups.google.com/d/topic/open-iscsi/owLIZAXfgoA/unsubscribe.
> To unsubscribe from this group and all its topics, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
