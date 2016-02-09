From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH 3/4] qla2xxx: Add DebugFS node for target sess list.
Date: Tue, 9 Feb 2016 21:30:46 +0000
Message-ID: <D2DF4A5F.D6CA2%himanshu.madhani@qlogic.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
 <1454604319-27947-4-git-send-email-himanshu.madhani@qlogic.com>
 <1454820035.10001.17.camel@haakon3.risingtidesystems.com>
 <D2DE0F32.D6BD5%himanshu.madhani@qlogic.com>
 <1454996942.10001.170.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454996942.10001.170.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Content-ID: <A1BC073EA76F0F49B075E5EA2A5F8DA7@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>
List-Id: linux-scsi@vger.kernel.org


On 2/8/16, 9:49 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>On Mon, 2016-02-08 at 17:43 +0000, Himanshu Madhani wrote:
>> >
>> >So looking at this patch beyond the debugfs part, it does change where
>> >->check_initiator_node_acl() gets call during qlt_create_sess().
>> >
>> >I assume this is related to new debugfs attribute, and these changes
>> >(plus others in qlt_del_sess_work_fn) are not bug-fixes on their own,
>> >correct..?
>> >
>> >Aside from that, I don't have an objection to merge as v4.6 for-next
>> >code if QLogic finds it useful for debugging.
>> 
>> Yes. The changes in this patch are strictly for making information
>> available via debugFS and not bug-fixes on their own.
>
>Thanks for clarifying.
>
>> This information has been requested by few customer who
>> finds this information useful for debugging and in addition they use
>>this
>> information in their configuration scripts as well.
>
>So I've got no particular objection to people adding debugfs
>informational attributes for whatever to aid debugging of their drivers.
>
>That said, the same information can too be exposed as a tcm_qla2xxx
>struct se_node_acl->acl_group configfs attribute, and for demo-mode
>sessions via a tcm_qla2xxx provided dynamic_sessions configfs attribute
>handler.
>
>I'd be happy to add expose this under tcm_qla2xxx configfs for v4.6 code
>if you'd like, otherwise I'm OK with the patch in queue-next as-is if
>you find it useful.
>

I really like your idea of exposing this information via configFS. Please
go ahead and make updates on exposing this information via
se_node_acl->acl_group
Configfs attribute. We can ask our customer to explore configfs to retrieve
information. However, We would also like to keep this information in
debugFS for now.

>
