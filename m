From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH V3 1/9] block: add a helper function to read
 nr_setcs
Date: Thu, 4 Jul 2019 00:11:48 +0000
Message-ID: <BYAPR04MB57492202BACDEE2991620E4D86FA0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
 <26917678-fd82-b6c8-761e-220bc7d3b179@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8352981984950808594=="
Return-path: <xen-devel-bounces@lists.xenproject.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: Bart Van Assche <bvanassche@acm.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "yuchao0@huawei.com" <yuchao0@huawei.com>, "colyli@suse.de" <colyli@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>
List-Id: linux-scsi@vger.kernel.org

--===============8352981984950808594==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BYAPR04MB57492202BACDEE2991620E4D86FA0BYAPR04MB5749namp_"

--_000_BYAPR04MB57492202BACDEE2991620E4D86FA0BYAPR04MB5749namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 7/3/19 8:03 AM, Bart Van Assche wrote:

+}


Is the comment above bdev_nr_sects() really useful or should it be left out=
?

Thanks,

Bart.



Sure, let me send V4 without the comment.

--_000_BYAPR04MB57492202BACDEE2991620E4D86FA0BYAPR04MB5749namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body text=3D"#000000" bgcolor=3D"#FFFFFF">
<div class=3D"moz-cite-prefix">On 7/3/19 8:03 AM, Bart Van Assche wrote:<br=
>
</div>
<blockquote type=3D"cite" cite=3D"mid:26917678-fd82-b6c8-761e-220bc7d3b179@=
acm.org">
<blockquote type=3D"cite" style=3D"color: #000000;">
<pre class=3D"moz-quote-pre" wrap=3D"">&#43;}=0A=
</pre>
</blockquote>
<pre class=3D"moz-quote-pre" wrap=3D"">Is the comment above bdev_nr_sects()=
 really useful or should it be left out?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
=0A=
</pre>
</blockquote>
Sure, let me send V4 without the comment.<br>
</body>
</html>

--_000_BYAPR04MB57492202BACDEE2991620E4D86FA0BYAPR04MB5749namp_--


--===============8352981984950808594==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWGVuLWRldmVs
IG1haWxpbmcgbGlzdApYZW4tZGV2ZWxAbGlzdHMueGVucHJvamVjdC5vcmcKaHR0cHM6Ly9saXN0
cy54ZW5wcm9qZWN0Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3hlbi1kZXZlbA==

--===============8352981984950808594==--
