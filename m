From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V3 1/4] Add XEN pvSCSI protocol description
Date: Mon, 04 Aug 2014 12:39:58 +0200
Message-ID: <53DF62FE.7030007@suse.com>
References: <1407140870-542-1-git-send-email-jgross@suse.com>	<1407140870-542-2-git-send-email-jgross@suse.com> <53DF78290200007800028E39@mail.emea.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53DF78290200007800028E39@mail.emea.novell.com>
Sender: target-devel-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com
List-Id: linux-scsi@vger.kernel.org

On 08/04/2014 12:10 PM, Jan Beulich wrote:
>>>> On 04.08.14 at 10:27, <JGross@suse.com> wrote:
>> +/* Requests from the frontend to the backend */
>> +
>> +/*
>> + * Request a SCSI operation specified via a CDB in vscsiif_request.cmnd.
>> + * The target is specified via channel, id and lun.
>> + */
>> +#define VSCSIIF_ACT_SCSI_CDB		1
>> +
>> +/*
>> + * Request abort of a running operation for the specified target given by
>> + * channel, id, lun and the operation's rqid in ref_rqid.
>> + */
>> +#define VSCSIIF_ACT_SCSI_ABORT		2
>> +
>> +/*
>> + * Request a device reset of the specified target (channel and id).
>> + */
>> +#define VSCSIIF_ACT_SCSI_RESET		3
>
> While I realize you don't want to support it, leaving out
> VSCSIIF_ACT_SCSI_SG_PRESET altogether from this header may
> lead people to the false impression that its number is available for
> other use. I would generally recommend the Linux headers to not
> deviate from the master ones more than absolutely necessary,
> keeping what isn't needed/wanted by Linux at least in commented
> out form.

Okay. I'll re-add the #define


Juergen
