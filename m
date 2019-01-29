From: Avri Altman <Avri.Altman-Sjgp3cTcYWE@public.gmane.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: Print uic error history in time order
Date: Tue, 29 Jan 2019 07:28:44 +0000
Message-ID: <SN6PR04MB49257E6E541B870867A96521FC970@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1548684266-8792-1-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1548684266-8792-1-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org" <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> 
> Now uic errors are printed out of time order.
> 
> Simply make it more readable by printing logs
> in time order, and printing "No record" if history
> is empty.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Reviewed-by: Avri Altman <avri.altman-Sjgp3cTcYWE@public.gmane.org>
