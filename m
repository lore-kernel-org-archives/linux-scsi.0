From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Subject: [RFC] drivers/scsi/dc395x.c - msgin_qtag()
Date: Fri, 15 Nov 2013 17:53:25 -0200
Message-ID: <CAGG-pUSG0sngtW_F3j=Koa1KmjsLKE-2RU9Jy5Zm_=eUoe5rOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi guys,

In the function msgin_qtag() [line 2632], this dereference was intentional?

static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
        struct DeviceCtlBlk *dcb, u8 tag)
{
    struct ScsiReqBlk *srb = NULL;
    struct ScsiReqBlk *i;
    dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
           srb->cmd, tag, srb);
...

There is a srb (NULL) dereference in the dprintkdbg() parameteres.

If not, what approach do you suggest me for a patch?

-- 
Regards,

Geyslan G. Bem
hackingbits.com
