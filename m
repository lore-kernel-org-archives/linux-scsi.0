From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch v2 2/2] libiscsi: Remove iscsi_destroy_session
Date: Thu, 14 Sep 2017 09:57:52 +0200
Message-ID: <20170914075752.6v45mlusxylkqckj@linux-x5ow.site>
References: <20170713161122.89375-1-khazhy@google.com>
 <20170713161122.89375-2-khazhy@google.com>
 <9be07c2e-71ef-cab4-7b04-94d33a191d03@suse.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDVNRMMDUUIBBA7N5DGQKGQEMWLLAKA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <9be07c2e-71ef-cab4-7b04-94d33a191d03-IBi9RG/b67k@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>
Cc: Khazhismel Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 13, 2017 at 05:09:03PM -0700, Lee Duncan wrote:
> On 07/13/2017 09:11 AM, Khazhismel Kumykov wrote:
> > iscsi_session_teardown was the only user of this function. Function
> > currently is just short for iscsi_remove_session + iscsi_free_session.
> >=20
> > Signed-off-by: Khazhismel Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> Why is this needed? I dislike changes that don't fix anything.

The function has no more users left after patch 1, so why keep it bitrottin=
g?

--=20
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
