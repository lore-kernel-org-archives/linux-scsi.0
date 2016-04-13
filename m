From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 08/16] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Wed, 13 Apr 2016 12:52:11 +0300
Message-ID: <570E16CB.8070708@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
 <570A92B0.9000109@grimberg.me> <20160411180838.GB1758@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160411180838.GB1758@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org


>>> Add void (*iscsit_get_r2t_ttt)() to
>>> struct iscsit_transport, iscsi-target
>>> uses this callback to get
>>> r2t->targ_xfer_tag.
>>
>> Your driver allocates ttt's? That looks like bad
>> layering to me. This definitely deserves an explanation...
>
> cxgbit.ko allocates ttt only for r2t pdus to do Direct Data
> Placement of Data Out pdus, adapter uses the ttt value in
> Data Out pdus to place data directly in the host buffers.

How do you guarantee that the core doesn't conflict with
your internal ttt's?
