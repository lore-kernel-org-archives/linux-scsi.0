From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: iSCSI and scsi-mq
Date: Wed, 25 Nov 2015 11:04:25 +0100
Message-ID: <1448445865.2877.71.camel@suse.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBDVNRMMDUUIBBK4P22ZAKGQE5SL3TDA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Jayamohan Kallickal <jayamohan.kallickal-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi iSCSI experts,

I've been starting to research possible implementations of a scsi-mq capabl=
e
iSCSI. With my research I found the following thread=C2=A0https://groups.go=
ogle.com/
forum/#!msg/open-iscsi/qLaXJh2Gqt4/A2NIDZ0fT9oJ=C2=A0and wondered what happ=
ened to
the efforts layed out there (and what have been the results of the discussi=
on
at LSF/MM).

The one TCP connection per CPU or HW queue approach sounds particularly
interesting to me when taking a SW iSCSI initiator. A problem Hannes pointe=
d
out here could be network topology changes which result in a different rout=
e on
a different NIC with a different number of HW queues, so it might not be th=
e
ultimate solution.

With the offload cards we might need to do something else.

Is there anyone else working on a scsi-mq for iSCSI at the moment and is
willing to join efforts here?

Byte,
	Johannes

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
