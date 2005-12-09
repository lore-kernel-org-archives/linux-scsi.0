From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: stgt a new version
 of iscsi target?
Date: Fri, 09 Dec 2005 18:30:07 +0300
Message-ID: <4399A2FF.6010307@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net> <4398814F.7000106@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <4398814F.7000106@cs.wisc.edu>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Vladislav Bolkhovitin wrote:
>=20
>> Mike Christie wrote:
>>
>>> johan@capvert.se wrote:
>>>
>>>> I, and I suppose a lot of other people, would like know how you look=
=20
>>>> at the
>>>> HW support on the Fc side? I don=B4t know what you mean now, when yo=
u=20
>>>> talk
>>>> about HW target support,=20
>>>
>>>
>>>
>>> For qlogic FC, it is the same as scst at this point, except we are=20
>>> based off the mainline qla2xxx driver.
>>
>>
>>
>> Actually, this is not completely true and could mislead people.  Stgt =
is
>> *not* the same as scst at this point and,
>=20
>=20
> Yes, I agree, I was not talking about functionality. I was only talking=
=20
> about how we interface with the initiator driver. My mistake. So we add=
=20
> a qla_tgt function callback struct (but we do it for each ha rather tha=
n=20
> global) so the initiator can call back into the target driver, so I am=20
> basically resusing that code.

OK, if you reuse scst code, I hope you won't forget to insert somewhere=20
reference to its original authors :-)




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
