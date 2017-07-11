From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2 01/15] qla2xxx: Combine Active command arrays.
Date: Tue, 11 Jul 2017 23:43:40 +0000
Message-ID: <1499816619.2586.53.camel@wdc.com>
References: <20170614034730.15428-1-himanshu.madhani@cavium.com>
         <20170614034730.15428-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170614034730.15428-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <E0A532A81582484599A630D30CE0D2B5@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-06-13 at 20:47 -0700, Himanshu Madhani wrote:
>  typedef struct srb {
> +	/*
> +	 * Do not move cmd_type field, it needs to
> +	 * line up with qla_tgt_cmd->cmd_type
> +	 */
> +	uint8_t cmd_type;
> +	uint8_t pad[3];

Hello Himanshu,

Had I understood correctly that you had promised to rework the command
array merging such that a union is used instead of requiring certain
fields to be present at certain offsets (see also
https://www.spinics.net/lists/target-devel/msg15591.html)?

Bart.=
